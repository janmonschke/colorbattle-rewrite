var gulp = require('gulp');
var browserify = require('gulp-browserify');
var rename = require('gulp-rename');
var gulpif = require('gulp-if');
var uglify = require('gulp-uglify');
var stylus = require('gulp-stylus');
var nib = require('nib');
var mocha = require('gulp-mocha');

var env = process.env.NODE_ENV || 'development';
var isDebugEnv = env == 'development';
var isProductionEnv = env == 'production';

gulp.task('coffee', function(){
  return gulp.src('app/app.coffee', { read: false })
        .pipe(browserify({
          debug: false,
          transform: ['coffeeify'],
          extensions: ['.coffee']
        }))
        .on('error', function(err){
          console.log('error', err.message);
        })
        .pipe(gulpif(isProductionEnv, uglify()))
        .pipe(rename('app.js'))
        .pipe(gulp.dest('public/'));
});

gulp.task('stylus', function(){
  var stylusOptions = {
    use: [nib()],
    compress: isProductionEnv
  };
  return gulp.src('styles/app.styl')
        .pipe(stylus(stylusOptions))
        .pipe(gulp.dest('public/'))
});

gulp.task('test', function(){
  require('coffee-script');
  require('should');
  return gulp.src('test/**/*.coffee', {read: false})
        .pipe(mocha({reporter: 'dot'}));
});

gulp.task('watch', function(){
  gulp.watch('app/**/*.coffee', ['coffee', 'test']);
  gulp.watch('test/**/*.coffee', ['test']);
  gulp.watch('server/**/*.coffee', ['test']);
  gulp.watch('styles/**/*.styl', ['stylus']);
});

gulp.task('default', ['coffee', 'stylus', 'test', 'watch']);
