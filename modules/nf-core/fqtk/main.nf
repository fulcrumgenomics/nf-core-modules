process FQTK {
    tag "$meta.id"
    label 'process_high'

    conda "bioconda::fqtk=0.2.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fqtk:0.2.0--h9f5acd7_0' :
        'quay.io/biocontainers/fqtk:0.2.0--h9f5acd7_0' }"

    input:
    tuple val(meta), path(sample_sheet), path(fastq_files), val(read) // from sgdemux and bases2fastq


    output:
    tuple val(meta), path('output/*R*.fq.gz')                       , emit: sample_fastq
    tuple val(meta), path('output/demux-metrics.txt')               , emit: metrics
    tuple val(meta), path('output/unmatched*.fq.gz')                , emit: most_frequent_unmatched
    // TODO: Nathan is adding version printing with fqtk
    path "versions.yml"                                             , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def VERSION = '0.2.0'
    """
    fqtk \\
        demux \\
            --inputs ${fastq_files} \\
            --read-structures ${read} \\
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