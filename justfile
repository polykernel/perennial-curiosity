build:
  forester build

serve:
  python3 -m http.server -b 127.0.0.1 -d output/

clean:
  rm -rf output

new-tree PREFIX:
  forester new --dest=trees --prefix={{PREFIX}}
