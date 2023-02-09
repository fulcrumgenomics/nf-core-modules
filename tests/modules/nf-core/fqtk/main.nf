#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FQTK  } from '../../../../modules/nf-core/fqtk/main.nf'
include { UNTAR   } from '../../../../modules/nf-core/untar/main.nf'

workflow test_fqtk {  
    def input = Channel.of ([ [ id:'sim-data'], // meta map
            file("/Users/swhite/projects/SINGULAR/nf-core-modules/fqtk_inputs/fqtk_sample_metadata_subset.tsv", checkIfExists: true),
            file("/Users/swhite/projects/SINGULAR/nf-core-modules/fqtk_inputs/reads.csv", checkIfExists: true)
    ])

    def fastqs = Channel
            .from(file("/Users/swhite/projects/SINGULAR/nf-core-modules/fqtk_inputs/reads.csv", checkIfExists: true))
            .splitCsv(header: true, skip: 0, strip: true )
            .map{[it.fastq, it.read_structure]}

    def fastqs_with_paths = fastqs.combine(
        UNTAR ([
            [ id:'sim-data' ],
            file("/Users/swhite/projects/SINGULAR/nf-core-modules/fqtk_inputs/fastqs/subsets/fqtk_subset.tar.gz", checkIfExists: true)
        ]).untar.collect{it[1]}
    ).toList()

    FQTK ( input, fastqs_with_paths )
}


