#!/usr/bin/env Rscript

# Validate the capsule PDFs linked by the public course site.

pdf_files <- sort(list.files(
  "modules",
  pattern = "capsule-[0-9]{2}-support(-annote)?\\.pdf$",
  recursive = TRUE,
  full.names = TRUE
))

pdf_files <- pdf_files[grepl("modules/semaine-0[1-5].*/media/pdf/", pdf_files)]

if (length(pdf_files) != 36L) {
  stop("36 PDF liés étaient attendus; ", length(pdf_files), " ont été trouvés.")
}

errors <- character()
total_pages <- 0L

for (pdf_path in pdf_files) {
  info <- system2("pdfinfo", pdf_path, stdout = TRUE, stderr = TRUE)
  status <- attr(info, "status")

  if (!is.null(status) && status != 0L) {
    errors <- c(errors, paste("PDF illisible:", pdf_path))
    next
  }

  pages_line <- grep("^Pages:", info, value = TRUE)
  size_line <- grep("^File size:", info, value = TRUE)
  pages <- as.integer(sub("^Pages:[[:space:]]+", "", pages_line))
  size <- as.numeric(sub("^File size:[[:space:]]+([0-9]+).*$", "\\1", size_line))

  if (length(pages) != 1L || is.na(pages) || pages < 8L) {
    errors <- c(errors, paste("Nombre de pages invalide:", pdf_path))
  } else {
    total_pages <- total_pages + pages
  }

  if (length(size) != 1L || is.na(size) || size < 50000) {
    errors <- c(errors, paste("Fichier PDF incomplet:", pdf_path))
  }

  public_path <- file.path("docs", pdf_path)
  if (!file.exists(public_path)) {
    errors <- c(errors, paste("Copie publique absente:", public_path))
  } else if (!identical(
    unname(tools::md5sum(pdf_path)),
    unname(tools::md5sum(public_path))
  )) {
    errors <- c(errors, paste("Copie publique désynchronisée:", public_path))
  }
}

cat("Validation des PDF de capsules MQT-2101\n")
cat("PDF vérifiés :", length(pdf_files), "\n")
cat("Pages PDF :", total_pages, "\n")
cat("Erreurs :", length(errors), "\n")

if (length(errors) > 0L) {
  cat(paste0("- ", errors), sep = "\n")
  stop("Validation des PDF échouée.")
}

cat("PDF liés et copies publiques validés.\n")
