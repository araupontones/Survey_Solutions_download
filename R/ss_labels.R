# list.files(dir_ss_downloads, recursive = T)
# 
# do = read_table2(file.path(dir_ss_downloads,"elp_classroom_3/elp_classroom.do"))
# 
# t = read_table2(file.path(dir_ss_downloads,"elp_classroom_3/elp_classroom.tab"))
# 
# attributes(t$co_numflr)
# 
# t$co_numflr
# ?read_table2
# read_ta
# 
# 
# dofile = file.path(dir_ss_downloads,"elp_classroom_3/elp_classroom.do")
# 
# d_t = read_table(dofile)  %>%
#   as_tibble() %>%
#   filter(str_detect(clear, "label define")) %>%
#   mutate(variable = str_extract(clear, "(?<=define\\s)(.*?)(?=\\s)"),
#          label = str_extract_all(clear, '(?<=\")([a-zA-Z]*?)(?=\")')
#          )


