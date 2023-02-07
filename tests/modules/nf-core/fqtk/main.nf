#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FQTK  } from '../../../../modules/nf-core/fqtk/main.nf'

workflow test_fqtk {    
    input = Channel.of ([ [ id:'sim-data'], // meta map
            file("/Users/swhite/projects/SINGULAR/nf-core-modules/fqtk_inputs/fqtk_sample_metadata_subset.tsv", checkIfExists: true),
            [
                file("/Users/swhite/projects/SINGULAR/nf-core-modules/fqtk_inputs/fastqs/subsets/Undetermined_S0_L001_I1_001_subset.fastq.gz", checkIfExists: true),
                file("/Users/swhite/projects/SINGULAR/nf-core-modules/fqtk_inputs/fastqs/subsets/Undetermined_S0_L001_I2_001_subset.fastq.gz", checkIfExists: true),
                file("/Users/swhite/projects/SINGULAR/nf-core-modules/fqtk_inputs/fastqs/subsets/Undetermined_S0_L001_R1_001_subset.fastq.gz", checkIfExists: true)
            ],
            '8B 8B 151T'
    ])
    FQTK ( input )
}
