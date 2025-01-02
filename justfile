build:
  forester build

serve:
  python3 -m http.server -b 127.0.0.1 -d output/

clean:
  rm -rf output
