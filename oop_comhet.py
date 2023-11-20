import pandas as pd


class Sample:
    def __init__(self, file_path):
        self.file_path = file_path
        self.data = pd.read_csv(file_path, sep='\t', low_memory=False)


class DataProcessor:
    def __init__(self, output_dir, fam):
        self.output_dir = output_dir
        self.fam = fam
        self.samples = []

    def add_sample(self, file_path):
        sample = Sample(file_path)
        self.samples.append(sample)

    def process_data(self):
        column_names = ['CHROM', 'POS', 'Gene_ID']
        # column_names += ['AF_' + str(self.samples) + str(i) for i in range(len(self.samples))]
        column_names += ['AF_' + sample.file_path.split('/')[-1][0:6] for sample in self.samples]
        column_names.append('gnomAD_WG_AF')

        df_final = pd.DataFrame(columns=column_names)

        for idx, row in self.samples[0].data.iterrows():
            af_values = ['NA'] * len(self.samples)

            for i, sample in enumerate(self.samples):
                same_row = sample.data[((sample.data['CHROM'] == row['CHROM']) &
                                        (sample.data['POS'] == row['POS']) &
                                        (sample.data['Gene_ID'] == row['Gene_ID']))]
                if not same_row.empty:
                    af_values[i] = same_row['AF'].iloc[0]
        

            df_final.loc[idx] = [row['CHROM'], row['POS'], row['Gene_ID']] + af_values + [row['gnomAD_WG_AF']]


        df_final = df_final[df_final.duplicated('Gene_ID', keep=False) == True]
        df_final.to_csv(self.output_dir + "comhet." + self.fam + ".tsv", sep="\t", header=True, index=False)


if __name__ == '__main__':
    
    group = input("Indicate group name: ")
    
    output_dir = "/home/vant/Escritorio/pid/"+group+"/oop/"

    fam = input("Indicate group's short name for output file: ")

    sample_file = input("Enter the path of the samples file: ")

    processor = DataProcessor(output_dir, fam)

    # Read the sample file and add samples to the processor
    with open(sample_file, 'r') as file:
        for line in file:
            line = line.strip()
            if line:
                processor.add_sample(line)

    # Process the data
    processor.process_data()
