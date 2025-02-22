#' @title pre conversion statistics
#' @description count common environments,inlines for debugging purposes
#' @param article_dir path to the directory which contains RJ article
#'
#' @return
#' @export
#'
#' @examples
pre_conversion_statistics <- function(article_dir){
    con_stat <- list()
    con_stat$table <- count_env(article_dir, "table")
    con_stat$figure <- count_env(article_dir, "figure")
    con_stat$math <- count_inline(article_dir, "math")
    con_stat$citations <- count_inline(article_dir, "cite")
    con_stat$codeblock <- count_env(article_dir, "verbatim")
    con_stat$inlinecode <- count_inline(article_dir, "inlinecode")
    return(con_stat)
}


conversion_coverage_checK <- function(article_dir) {

}

#' @title count latex environments
#' @description count common environments like table,figure,verbatim etc..
#' @param article_dir path to the directory which contains RJ article
#' @param env_name name of the environment
#'
#' @return count of the environment
#' @export
#'
#' @examples
#' article_dir <- system.file("examples/article",
#'                  package = "texor")
#' table <- texor::count_env(article_dir, "figure")
#' print(paste("figure count : ", figures))
count_env <- function(article_dir, env_name) {
    # find tex file
    file_name <- get_texfile_name(article_dir)
    file_path <- paste(article_dir, file_name, sep = "/")
    # readLines
    raw_lines <- readLines(file_path)
    begin_patt <- paste("\\s*\\\\begin\\{", env_name, "\\}", sep = "")
    end_patt <- paste("\\s*\\\\end\\{", env_name, "\\}", sep = "")
    begin_break_points <- which(grepl(begin_patt, raw_lines))
    end_break_points <-  which(grepl(end_patt, raw_lines))
    # to do (ignore commented code)
    # if an environment opens and closes then the breakpoints would
    # be equal in length, otherwise it may indicate something wrong

    if (length(begin_break_points) == length(end_break_points)) {
        return(length(begin_break_points))
    }
    if (length(begin_break_points) < length(end_break_points)) {
        return(length(end_break_points))
    } else {
        return(length(begin_break_points))
    }
}
#' @title count inline elements
#' @description  counts inline elements embedded within the latex file
#' currently supported inlines : math (based on $$), code (based on \\code)
#' and Citations (based on \\cite,\\citealp, \\citep, \\citet)
#'
#' @param article_dir path to the directory which contains RJ article
#' @param inline name of the inline element
#'
#' @return count of the inline element
#' @export
#'
#' @examples
#' article_dir <- system.file("examples/article",
#'                  package = "texor")
#' math <- texor::count_inline(article_dir, "math")
#' code <- texor::count_inline(article_dir, "inlinecode")
#' cite <- texor::count_inline(article_dir, "cite")
#' print(paste("math inlines : ", math, "\n",
#'             "code inlines : ", code, "\n",
#'             "citations    : ", cite))
count_inline <- function(article_dir, inline) {
    # find tex file
    file_name <- get_texfile_name(article_dir)
    file_path <- paste(article_dir, file_name, sep = "/")
    # readLines
    raw_lines <- readLines(file_path)
    raw_words <- str_split(raw_lines," ")
    # filters comments in the given tex file
    comments <- which(grepl("\\%",raw_lines))
    for ( comment in comments) {
        raw_lines[comment] <- ""
    }
    if (tolower(inline) == "math"){
        begin_patt <- "\\$\\s*(.*?)\\s*\\$"
        begin_break_points <- which(grepl(begin_patt,raw_lines))
        count <- 0
        for (pos in begin_break_points) {
            raw_words <- str_split(raw_lines[pos]," ")
            for (word in raw_words[[1]]) {
                if (grepl(begin_patt, word)) {
                    count = count + 1
                }
            }
        }
        return(count)
    }
    if (tolower(inline) == "inlinecode") {
        count <- 0
        begin_patt <- "\\\\code\\{"
        begin_break_points <- which(grepl(begin_patt,raw_lines))
        for (pos in begin_break_points) {
            raw_words <- str_split(raw_lines[pos]," ")
            for (word in raw_words[[1]]) {
                if (grepl(begin_patt, word)) {
                    count = count + 1
                }
            }
        }
        return(count)
    }
    if (tolower(inline) == "cite") {
        count <- 0
        begin_patt <- c("\\\\cite\\{",
                        "\\\\citealp\\{",
                        "\\\\citet\\{",
                        "\\\\citep\\{")
        cite_break_points <- which(grepl(begin_patt[1],raw_lines))
        citealp_break_points <- which(grepl(begin_patt[2],raw_lines))
        citet_break_points <- which(grepl(begin_patt[3],raw_lines))
        citep_break_points <- which(grepl(begin_patt[4],raw_lines))
        if (!identical(cite_break_points,integer(0))) {
            for (pos in cite_break_points) {
                raw_words <- str_split(raw_lines[pos]," ")
                for (word in raw_words[[1]]) {
                    if (grepl(begin_patt[1], word)) {
                        count = count + 1
                    }
                }
            }
        }
        if (!identical(citealp_break_points,integer(0))) {
            for (pos in citealp_break_points) {
                raw_words <- str_split(raw_lines[pos]," ")
                for (word in raw_words[[1]]) {
                    if (grepl(begin_patt[2], word)) {
                        count = count + 1
                    }
                }
            }
        }
        if (!identical(citep_break_points,integer(0))) {
            for (pos in citep_break_points) {
                raw_words <- str_split(raw_lines[pos]," ")
                for (word in raw_words[[1]]) {
                    if (grepl(begin_patt[4], word)) {
                        count = count + 1
                    }
                }
            }
        }
        if (!identical(citet_break_points,integer(0))) {
            for (pos in citet_break_points) {
                raw_words <- str_split(raw_lines[pos]," ")
                for (word in raw_words[[1]]) {
                    if (grepl(begin_patt[3], word)) {
                        count = count + 1
                    }
                }
            }
        }
        return(count)
    } else {
        return(0)
    }

}
