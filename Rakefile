ENV["LANG"] = "C"

CC = "./cbc.sh"

TEMP_DIR = "z_tmp"

SRC_UTILS     = "lib/utils.cb"
SRC_TYPES     = "lib/types.cb"
SRC_JSON      = "lib/json.cb"

BINS = [
  "bin/test_json",
  "bin/vgtokenizer",
  "bin/vgparser",
  "bin/vgcg",
]

def temp_path(path)
  File.join(TEMP_DIR, path)
end

def compile(t)
  main_file = t.prerequisites[0]
  preprocessed = temp_path("pp_" + File.basename(main_file))
  sh %(ruby preproc.rb #{main_file} > #{preprocessed})
  sh %(#{CC} #{preprocessed} -o #{t.name})
end

# --------------------------------

task :default => :build

task :build => BINS

task :clean do
  BINS.each{ |bin_path|
    sh "rm -f #{bin_path}"
  }
  sh "rm -f *.o *.s"
  sh "rm -f z_tmp/*"
end

file "bin/test_json" => ["lib/test_json.cb", SRC_UTILS, SRC_TYPES, SRC_JSON] do |t|
  compile(t)
end

file "bin/vgtokenizer" => ["vgtokenizer.cb", SRC_UTILS] do |t|
  compile(t)
end

file "bin/vgparser" => ["vgparser.cb", SRC_UTILS, SRC_TYPES, SRC_JSON] do |t|
  compile(t)
end

file "bin/vgcg" => ["vgcg.cb", SRC_UTILS, SRC_TYPES, SRC_JSON] do |t|
  compile(t)
end
