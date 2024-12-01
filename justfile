build:
  forester build
  rm -r output/{bundle-js.sh,package.json,package-lock.json,javascript-source/}
  cp CNAME index.html output/

clean:
  rm -rf output
