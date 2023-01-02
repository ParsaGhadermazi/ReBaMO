
process merge_lanes {

    input:
        path sample
    output:
        tuple path("${sample}/${sample}_Ready_R1.fq.gz"),path("${sample}/${sample}_Ready_R2.fq.gz")

    script:
    """
    R1=\$(ls ${sample}/*R1*)
    R2=\$(ls ${sample}/*R2*)
    NumR1=\$(echo \$R1|wc -l)
    NumR2=\$(echo \$R2|wc -l)
    if [ \$NumR1 == \$NumR2 ];then 
    if [ \$NumR1>1 ];then
    zcat < ${sample}/*R1*|gzip -c > ${sample}/${sample}_Ready_R1.fq.gz
    zcat < ${sample}/*R2*|gzip -c > ${sample}/${sample}_Ready_R2.fq.gz
    else 
    mv ${sample}/*R1* ${sample}/${sample}_Ready_R1.fq.gz
    mv ${sample}/*R2* ${sample}/${sample}_Ready_R2.fq.gz      
    fi
    fi
    """


}



workflow {
    merged_samples=Channel.fromPath("$params.samplesdir/*",type:'dir',hidden:false)|merge_lanes
}