#!/bin/bash
domain=$1
output_file="${domain}.csv"

whois "$domain" | awk -F': ' '
BEGIN {
    # Çıxışda olacaq bölmələrin və sahələrin siyahısı
    split("Registrant,Admin,Tech", sections, ",")
    split("Name,Organization,Street,City,State/Province,Postal Code,Country,Phone,Phone Ext:,Fax,Fax Ext:,Email", fields, ",")
}
{
    # whois çıxışındakı açar və dəyərləri təmizləyib massivə yığırıq
    key = $1; sub(/^[ \t]+/, "", key); sub(/[ \t]+$/, "", key);
    val = $2; sub(/^[ \t]+/, "", val); sub(/[ \t]+$/, "", val);
    if (key != "") {
        data[key] = val
    }
}
END {
    final_output = ""
    for (s = 1; s <= 3; s++) {
        for (f = 1; f <= 12; f++) {
            sec_name = sections[s]
            fld_name = fields[f]

            # "Ext:" sahələri üçün xüsusi qayda (həmişə kolon daxil edilir)
            if (fld_name ~ /Ext:/) {
                line = sec_name " " fld_name ","
            } else {
                # Açar sözü qururuq (məs: "Registrant Name")
                lookup_key = sec_name " " fld_name
                value = data[lookup_key]

                # "Street" sahəsi üçün sonuna boşluq əlavə etmək qaydası
                if (fld_name == "Street" && value != "") {
                    value = value " "
                }
                line = sec_name " " fld_name "," value
            }

            # Sətirləri birləşdiririk (sonuncu sətirdə newline olmaması üçün)
            if (final_output == "") {
                final_output = line
            } else {
                final_output = final_output "\n" line
            }
        }
    }
    # Faylın sonunda artıq boş sətir (newline) olmaması üçün printf istifadə edirik
    printf "%s", final_output
}' > "$output_file"
