library(pacman)
p_load(rvest, dplyr, utils, httr)

link <- "https://www.matematica.pt/en/useful/kangaroo-questions.php"
page <- read_html(link)
base_link <- page %>% html_elements("base") %>% html_attr("href")
pdf_links <- page %>% html_elements(".FileDown")  %>% html_attr("href")

main_folder <- "/Users/**/Downloads/Kangaroo_math"
outfile <- file.path(main_folder, "README.md")
current_year <- ""
for (i in seq_along(pdf_links)) {
    year <- strsplit(pdf_links[i], "/")[[1]][4]
    file_name <- strsplit(pdf_links[i], "/")[[1]][5]
    download_folder <- file.path(main, year)
    print(year)
    if (current_year != year) {
        write(c(sprintf("# %s", year), '\n', '- ', file.path(base_link, pdf_links[i]), '\n'), file = outfile, append = TRUE) # nolint
        current_year <- year
    }
    write(c("- ", file.path(base_link, pdf_links[i]), '\n'), file = outfile, append = TRUE) # nolint

    if (dir.exists(download_folder)) {
        GET(file.path(base_link, pdf_links[i]),
            user_agent("Mozilla/5.0"),
            write_disk(file.path(download_folder, file_name), overwrite = TRUE)) # nolint
    }
    else {
        dir.create(download_folder)
        GET(file.path(base_link, pdf_links[i]),
            user_agent("Mozilla/5.0"),
            write_disk(file.path(download_folder, file_name), overwrite = TRUE)) # nolint
    }
}
