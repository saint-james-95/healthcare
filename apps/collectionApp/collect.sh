if [ "$NPI" = true ]; then
	wget -r http://download.cms.gov/nppes/NPI_Files.html
	cd download.cms.gov/
	cd nppes/
	rm -rf css images NPI_Files.html *Weekly.zip *Report*
	mv NPPES_Data_Dissemination* ../../
	cd ../../
	rm -r download.cms.gov
	unzip NPPES_Data_Dissemination*.zip
	rm -r NPPES* *FileHeader.csv
fi

if [ "$NUCC" = true ]; then
	wget http://www.nucc.org/images/stories/CSV/nucc_taxonomy_150.csv
fi

if [ "$MEDICARE" = true ]; then
	wget "http://download.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Downloads/Medicare_Provider_Util_Payment_PUF_CY${MEDICARE_YEAR}.zip?agree=yes&next=Accept"
	unzip "Medicare_Provider_Util_Payment_PUF_CY${MEDICARE_YEAR}.zip?agree=yes&next=Accept"
	rm CMS_AMA_CPT_license_agreement.pdf "Medicare_Provider_Util_Payment_PUF_CY${MEDICARE_YEAR}.zip?agree=yes&next=Accept" Medicare-Physician-and-Other-Supplier-PUF-SAS-Infile.sas
fi
