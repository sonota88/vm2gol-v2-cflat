素朴な自作言語のコンパイラをC♭に移植した - memo88  
https://memo88.hatenablog.com/entry/2020/09/13/133735

```sh
docker build \
  --build-arg USER=$USER \
  --build-arg GROUP=$(id -gn) \
  -t vm2gol-v2-cflat:0.0.1 .

./docker_run.sh cbc --version
#=> cbc version 1.0.0

./test.sh all
```

```
$ LANG=C wc -l vg{lexer,parser,codegen}.cb lib/{utils,types,json}.cb

  193 vglexer.cb
  715 vgparser.cb
  584 vgcodegen.cb
  143 lib/utils.cb
  372 lib/types.cb
  199 lib/json.cb
 2206 total

$ cat vg{lexer,parser,codegen}.cb lib/{utils,types,json}.cb \
  | grep -v '^ *//' \
  | wc -l

2181
```
