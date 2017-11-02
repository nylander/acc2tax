# acc2tax

Richard.Leggett@tgac.ac.uk

Given a file of accessions or Genbank IDs (one per line), this program will return a taxonomy string for each.

Lookup for Genbank IDs is quicker than for accessions, as the lookup table is stored in RAM (though this does mean it takes a couple of minutes to load). For accessions, the lookup is from disc.

Database files can be downloaded from:

[ftp://ftp.ncbi.nih.gov/pub/taxonomy](ftp://ftp.ncbi.nih.gov/pub/taxonomy)

The files required are:

- nodes.dmp
- names.dmp
- gi_taxid_nucl.dmp
- gi_taxid_prot.dmp

For accessions, you will need a merged sorted copy of some of the files from the accession2taxid directory:

- nucl_est.accession2taxid
- nucl_gb.accession2taxid
- nucl_gss.accession2taxid
- nucl_wgs.accession2taxid
- dead_nucl.accession2taxid
- dead_wgs.accession2taxid
- prot.accession2taxid dead
- prot.accession2taxid

For the latter files, you need to:

    cat nucl_est.accession2taxid  nucl_gb.accession2taxid \
        nucl_gss.accession2taxid  nucl_wgs.accession2taxid \
        dead_nucl.accession2taxid dead_wgs.accession2taxid |\
        sort > acc2tax_nucl_all.txt

    cat prot.accession2taxid dead_prot.accession2taxid |\
        sort > acc2tax_prot_all.txt


and place these files in the same directory as the above database files.

To compile, type:

    make

For details of running, type:

    acc2tax -h

Example:

    ./acc2tax -d $HOME/db/taxonomy -i infile.nucl -o outfile.nucl

