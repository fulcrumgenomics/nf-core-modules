process FQTK {
    tag "$meta.id"
    label 'process_high'

    conda "bioconda::fqtk=0.2.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fqtk:0.2.0--h9f5acd7_0' :
        'quay.io/biocontainers/fqtk:0.2.0--h9f5acd7_0' }"

    input:
    tuple val(meta), path(sample_sheet), path(fastq_dir)
    val(fastq_readstructure_pairs) 
    // fastq_readstructure_pair example:
    // [[<fastq name: string>, <read structure: string>, <path to fastqs: path>], [example_R1.fastq.gz, 150T, ./work/98/30bc..78y/fastqs/]]

    output:
    tuple val(meta), path('output/*R*.fq.gz')                       , emit: sample_fastq
    tuple val(meta), path('output/demux-metrics.txt')               , emit: metrics
    tuple val(meta), path('output/unmatched*.fq.gz')                , emit: most_frequent_unmatched
    path "versions.yml"                                             , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def VERSION = '0.2.0'
    fastqs = fastq_readstructure_pairs.collect{it[2]/it[0]}.join(" ")
    read_structures = fastq_readstructure_pairs.collect{it[1]}.join(" ")

    """
    mkdir output
    fqtk \\
        demux \\
            --inputs ${fastqs} \\
            --read-structures ${read_structures} \\
            --output-types T \\
            --output output/ \\
            --sample-metadata ${sample_sheet} \\
            ${args}
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fqtk: $VERSION
    END_VERSIONS
    """
}

