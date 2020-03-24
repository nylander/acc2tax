#!/bin/bash

#  Description: Download taxonomy files from NCBI, and
#               prepare files for acc2tax.
#      Version: 11/03/2017 11:00:27 AM
#         Sign: Johan Nylander
#      Sources: ftp://ftp.ncbi.nih.gov/pub/taxonomy/
# Requirements: pigz, wget
#        Notes: acc2tax s from https://github.com/richardmleggett/acc2tax
#               Check the directory tree and URLs on genbank often,
#               links might change!
#         TODO: Consider downloading several files in parallel

set -euo pipefail

UNPIGZ=$(which unpigz)
if [ ! -x "$UNPIGZ" ]; then
  echo "unpigz can not be found in the PATH. Quitting."
  exit 1
fi

WGET=$(which wget)
if [ ! -x "$WGET" ]; then
  echo "wget can not be found in the PATH. Quitting."
  exit 1
fi

MD5SUM=$(which md5sum)
if [ ! -x "$MD5SUM" ]; then
  echo "md5sum can not be found in the PATH. Quitting."
  exit 1
fi

#mkdir -p taxonomy && cd taxonomy

start=$(date +%s)

## Get taxon tree
echo "Get taxon tree"
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/"
f="taxdump.tar.gz"
m="${f}.md5"
if [ -e "$f" ] ; then
    if [ -e "$m" ] ; then
        rm -v "$m"
    fi
    ${WGET} "${url}${m}"
    if ${MD5SUM} --status -c ${m} ; then
        echo "${f} seems to be up to date, skipping"
    else
        rm -v "$f"
        ${WGET} "${url}${f}" && tar --overwrite --extract -v -z -f "$f"
    fi
else
    ${WGET} "${url}${m}"
    ${WGET} "${url}${f}" && tar --overwrite --extract -v -z -f "$f"
fi

## Get GI to taxids for nucl
echo "Get GI to taxids for nucl"
f="gi_taxid_nucl.dmp.gz"
m="${f}.md5"
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/"
if [ -e "$f" ] ; then
    if [ -e "$m" ] ; then
        rm -v "$m"
    fi
    ${WGET} "${url}${m}"
    if ${MD5SUM} --status -c ${m} ; then
        echo "${f} seems to be up to date, skipping"
    else
        rm -v "$f"
        ${WGET} "${url}${f}" && ${UNPIGZ} --keep "$f"
    fi
else
    ${WGET} "${url}${m}"
    ${WGET} "${url}${f}" && ${UNPIGZ} --keep "$f"
fi

## Get GI to taxids for prot
echo "Get GI to taxids for prot"
f="gi_taxid_prot.dmp.gz"
m="${f}.md5"
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/"
if [ -e "$f" ] ; then
    if [ -e "$m" ] ; then
        rm -v "$m"
    fi
    ${WGET} "${url}${m}"
    if ${MD5SUM} --status -c ${m} ; then
        echo "${f} seems to be up to date, skipping"
    else
        rm -v "$f"
        ${WGET} "${url}${f}" && ${UNPIGZ} --keep "$f"
    fi
else
    ${WGET} "${url}${m}"
    ${WGET} "${url}${f}" && ${UNPIGZ} --keep "$f"
fi

## Get Accessions to taxids for nucl
echo "Get Accessions to taxids for nucl"
nuclarray=(nucl_est.accession2taxid.gz nucl_gb.accession2taxid.gz nucl_gss.accession2taxid.gz nucl_wgs.accession2taxid.gz dead_nucl.accession2taxid.gz dead_wgs.accession2taxid.gz)
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/"
for f in ${nuclarray[@]} ; do
    if [ -e "$f" ] ; then
        rm -v "$f"
    fi
    ${WGET} "${url}${f}" && $UNPIGZ -f "$f"
done

## Get Accessions to taxids for prot
echo "Get Accessions to taxids for prot"
protarray=(prot.accession2taxid.gz dead_prot.accession2taxid.gz)
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/"
for f in ${protarray[@]} ; do
    if [ -e "$f" ] ; then
        rm -v "$f"
    fi
    ${WGET} "${url}${f}" && ${UNPIGZ} -f "$f"
done

## Merge and sort files for acc2tax
echo "Merge and sort files for acc2tax"
cat *nucl_*.accession2taxid dead_wgs.accession2taxid  | sort > acc2tax_nucl_all.txt
cat *prot.accession2taxid | sort > acc2tax_prot_all.txt

## End of script
end=$(date +%s)
runtime=$((end-start))
echo "Elapsed time: $runtime"
echo "End of script"

