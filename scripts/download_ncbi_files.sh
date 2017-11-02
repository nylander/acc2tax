#!/bin/bash

#      Version: 11/02/2017 11:17:22 AM
#         Sign: JN
#      Sources: ftp://ftp.ncbi.nih.gov/pub/taxonomy/
# Requirements: wget, pigz
#        Notes: acc2tax s from https://github.com/richardmleggett/acc2tax
#               Check the directory tree and URLs on genbank often.
#         TODO: Consider downloading several files in parallel

set -euo pipefail

mkdir -p taxonomy && cd taxonomy

## Get taxon tree
echo "Get taxon tree"
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/"
f="taxdump.tar.gz"
if [ -e "$f" ] ; then
    rm -v "$f"
    rm -v *.dmp
fi
wget "${url}${f}" && tar --overwrite --extract -v -z -f "$f"

## Get GI to taxids for nucl
echo "Get GI to taxids for nucl"
f="gi_taxid_nucl.dmp.gz"
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/"
if [ -e "$f" ] ; then
    rm -v $f
fi
wget "${url}${f}" && unpigz "$f"

## Get GI to taxids for prot
echo "Get GI to taxids for prot"
f="gi_taxid_prot.dmp.gz"
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/"
if [ -e "$f" ] ; then
    rm -v "$f"
fi
wget "${url}${f}" && unpigz "$f"

## Get Accessions to taxids for nucl
echo "Get Accessions to taxids for nucl"
nuclarray=(nucl_est.accession2taxid.gz nucl_gb.accession2taxid.gz nucl_gss.accession2taxid.gz nucl_wgs.accession2taxid.gz dead_nucl.accession2taxid.gz dead_wgs.accession2taxid.gz)
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/"
for f in ${nuclarray[@]} ; do
    if [ -e "$f" ] ; then
        rm -v "$f"
    fi
    wget "${url}${f}" && unpigz -f "$f"
done

## Get Accessions to taxids for prot
echo "Get Accessions to taxids for prot"
protarray=(prot.accession2taxid.gz dead_prot.accession2taxid.gz)
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/"
for f in ${protarray[@]} ; do
    if [ -e "$f" ] ; then
        rm -v "$f"
    fi
    wget "${url}${f}" && unpigz -f "$f"
done

## Merge and sort files for acc2tax
echo "Merge and sort files for acc2tax"
cat *nucl_*.accession2taxid dead_wgs.accession2taxid  | sort > acc2tax_nucl_all.txt
cat *prot.accession2taxid | sort > acc2tax_prot_all.txt


