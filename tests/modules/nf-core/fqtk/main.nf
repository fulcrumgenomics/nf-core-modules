#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FQTK  } from '../../../../modules/nf-core/fqtk/main.nf'
include { UNTAR   } from '../../../../modules/nf-core/untar/main.nf'

workflow test_fqtk {  
    def input = Channel.of ([ [ id:'sim-data'], // meta map
            file("https://github.com/nf-core/test-datasets/raw/demultiplex/testdata/sim-data/fqtk_sample_metadata_subset.tsv", checkIfExists: true)
    ])

    def fastqs = Channel
            .from(file("https://github.com/nf-core/test-datasets/raw/demultiplex/testdata/sim-data/read_structure_manifest.csv", checkIfExists: true))
            .splitCsv(header: true, skip: 0, strip: true )
            .map{[it.fastq, it.read_structure]}

    def fastqs_with_paths = fastqs.combine(
        UNTAR ([
            [ id:'sim-data' ],
            file("https://github.com/nf-core/test-datasets/blob/demultiplex/testdata/sim-data/fastq.tar.gz?raw=true", checkIfExists: true)
        ]).untar.collect{it[1]}
    ).toList()

    ch_input = input.merge( fastqs_with_paths ) { a,b -> tuple(a[0], a[1], b)}

    FQTK ( ch_input )
}
