build:
  forester build
  rm -r output/{bundle-js.sh,package.json,package-lock.json,javascript-source/}
  cp CNAME index.html output/

serve:
  python3 -m http.server -b 127.0.0.1 -d output/

clean:
  rm -rf output
