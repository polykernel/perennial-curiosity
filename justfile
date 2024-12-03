build:
  forester build
  rm -r output/{bundle-js.sh,package.json,package-lock.json,javascript-source/}
  cp CNAME index.html output/

serve:
  python3 -m http.server -b localhost -d output/

clean:
  rm -rf output
