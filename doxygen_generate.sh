echo "Doxygen Generation."
date

# variables
TRAVIS_REPO_NAME=${TRAVIS_REPO_SLUG#*/}
DOXY_DIR=doxydir
DOXY_FILE=${TRAVIS_BUILD_DIR}/Doxyfile

# git config
git config user.name "Travis CI"
git config user.email "travis@travis-ci.org"
git config --global push.default simple

# clone gh-pages branch into working directory
cd $TRAVIS_BUILD_DIR
mkdir ${DOXY_DIR}
cd ${DOXY_DIR}
git clone -b gh-pages https://github.com/${TRAVIS_REPO_SLUG}.git
cd $TRAVIS_BUILD_DIR

# run Doxygen
curl -SLs https://raw.githubusercontent.com/adafruit/travis-ci-arduino/master/Doxyfile.default > ${DOXYFILE}
sed -i "s;^HTML_OUTPUT .*;HTML_OUTPUT = ${DOXY_DIR}/${TRAVIS_REPO_NAME}/html;"  ${DOXYFILE}
doxygen ${DOXYFILE}

# push to gh-pages branch
cd ${DOXY_DIR}/${TRAVIS_REPO_NAME}
git add .
git commit -m "Travis built docs "
git push --force "https://${GH_REPO_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" > /dev/null 2>&1