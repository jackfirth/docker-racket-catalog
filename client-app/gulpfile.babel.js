import gulp from 'gulp';
import gutil from 'gulp-util';
import concat from 'gulp-concat';

import browserify from 'browserify';
import babelify from 'babelify';
import source from 'vinyl-source-stream';

import R from 'ramda';


const SOURCE_DIR = 'src';
const ASSETS_DIR = 'assets';


const assetsPath = R.concat(ASSETS_DIR);
const sourcePath = R.concat(SOURCE_DIR);


const VIEWS_PATH = sourcePath('/*.html');
const TEMPLATES_PATH = sourcePath('/features/**/*.html');
const APP_ENTRY_POINT = sourcePath('/catalog.js');


gulp.task('build:views', () => {
  return gulp.src(VIEWS_PATH)
    .pipe(gulp.dest(assetsPath('/')));
});


gulp.task('build:templates', () => {
  return gulp.src(TEMPLATES_PATH)
    .pipe(gulp.dest(assetsPath('/templates')));
});


const logBundleError = (err) => {
  gutil.log('Error bundling components: ', err.message);
};


gulp.task('build:components', () => {
  return browserify(APP_ENTRY_POINT, {debug: true})
    .transform(babelify)
    .bundle()
    .on('error', logBundleError)
    .pipe(source('bundle.js'))
    .pipe(gulp.dest(assetsPath('/js')));
});


gulp.task('build', [
  'build:views',
  'build:templates',
  'build:components'
]);
