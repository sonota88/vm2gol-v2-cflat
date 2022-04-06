ENV["LANG"] = "C"

CC = "cbc"

TEMP_DIR = "z_tmp"

SRC_UTILS = "lib/utils.cb"
SRC_TYPES = "lib/types.cb"
SRC_JSON  = "lib/json.cb"

BINS = [
  "bin/test_json",
  "bin/vglexer",
  "bin/vgparser",
  "bin/vgcg",
]

def temp_path(path)
  File.join(TEMP_DIR, path)
end

def compile(t)
  main_file = t.prerequisites[0]
  preprocessed = "pp_" + File.basename(main_file)
  sh %(ruby preproc.rb #{main_file} > #{TEMP_DIR}/#{preprocessed})

  bin_bname = File.basename(t.name)
  cd TEMP_DIR do
    sh %(#{CC} #{preprocessed} -o #{bin_bname})
  end

  sh %(mv #{TEMP_DIR}/#{bin_bname} #{t.name})
end

# --------------------------------

task :default => :build

task :build => BINS

task :clean do
  BINS.each{ |bin_path|
    sh "rm -f #{bin_path}"
  }
  sh "rm -f z_tmp/*"
end

file "bin/test_json" => ["lib/test_json.cb", SRC_UTILS, SRC_TYPES, SRC_JSON] do |t|
  compile(t)
end

file "bin/vglexer" => ["vglexer.cb", SRC_UTILS] do |t|
  compile(t)
end

file "bin/vgparser" => ["vgparser.cb", SRC_UTILS, SRC_TYPES, SRC_JSON] do |t|
  compile(t)
end

file "bin/vgcg" => ["vgcg.cb", SRC_UTILS, SRC_TYPES, SRC_JSON] do |t|
  compile(t)
end
