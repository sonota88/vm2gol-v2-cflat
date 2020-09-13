# coding: utf-8

LF = "\n"
Encoding.default_external = "utf-8"

def collect_macro_defs(src)
  map = {}

  src.each_line{ |line|
    if /^#define (.+?) (.+)/ =~ line
      map[$1] = $2
    end
  }

  map
end

def modify_line(line, path, lineno, macro_defs)
  work_line = line
    .gsub("EOF", "/*EOF*/-1")
    .gsub("__LINE__", "/*__LINE__*/#{lineno}")
    .gsub("__FILE__", %(/*__FILE__*/"#{path}"))

  macro_defs.each{ |k, v|
    work_line.gsub!(k, "/*#{k}*/#{v}")
  }

  "/* #{path}: #{lineno} */ " + work_line
end

def modify_src(path)
  new_src = ""

  unless File.exist?(path)
    return ""
  end

  src = File.read(path)
  macro_defs = collect_macro_defs(src)
  new_src << LF
  lineno = 0

  src.each_line{ |line|
    lineno += 1
    if /^#define / =~ line
      new_src << modify_line("// " + line, path, lineno, {})
    else
      new_src << modify_line(line, path, lineno, macro_defs)
    end
  }

  new_src << LF

  new_src
end

def preproc(path)
  src = File.read(path)
  new_src = ""
  lineno = 0

  macro_defs = collect_macro_defs(src)

  src.each_line{ |line|
    lineno += 1

    if m = %r{^import (.+);}.match(line)
      import_target_path = m[1].gsub(".", "/")
      new_src << modify_src(import_target_path + ".hb")
      new_src << modify_src(import_target_path + ".cb")
      in_import = true
    elsif /^#define / =~ line
      new_src << modify_line("// " + line, path, lineno, {})
    else
      new_src << modify_line(line, path, lineno, macro_defs)
    end
  }

  print new_src
end

preproc ARGV[0]
