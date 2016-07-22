# Build Dependencies
gulp = require('gulp')
uglify = require('gulp-uglify')
usemin = require('gulp-usemin')
connect = require('gulp-connect')
coffee = require('gulp-coffee')
sass = require('gulp-sass')
rename = require('gulp-rename')
concat = require('gulp-concat')
sourcemaps = require('gulp-sourcemaps')
templatecache = require('gulp-angular-templatecache')

# Path definitions
paths =
    index: [
        'assets/index.html'
    ]
    coffee: [
        'assets/coffee/**/*.module.coffee'
        'assets/coffee/**/*.coffee'
    ]
    styles: [
        'assets/scss/**/*.scss'
    ]
    mainStyle: [
        'assets/scss/app.scss'
    ]
    images: [
        'assets/img/**/*'
    ]
    fonts: [
        'assets/components/**/*.{ttf,woff,eof,eot,svg,woff2,otf}'
    ]
    templates: [
        'assets/templates/**/*.html'
    ]
    dest: 'dist'


# Atomic Tasks
gulp.task 'usemin', ()->
    return gulp.src(paths.index)
    .pipe(usemin())
    .pipe(gulp.dest(paths.dest))

gulp.task 'coffee', ()->
    return gulp.src(paths.coffee)
    .pipe(sourcemaps.init())
    .pipe(coffee())
    .pipe(concat('app.min.js'))
    .pipe(uglify())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(paths.dest))

gulp.task 'styles', ()->
    return gulp.src(paths.mainStyle)
    .pipe(sourcemaps.init())
    .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
    .pipe(rename(basename: 'app.min'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(paths.dest))

gulp.task 'images', ()->
    return gulp.src(paths.images)
    .pipe(rename({dirname: '/'}))
    .pipe(gulp.dest("#{paths.dest}/img"))

gulp.task 'fonts', ()->
    return gulp.src(paths.fonts)
    .pipe(rename({dirname: '/'}))
    .pipe(gulp.dest("#{paths.dest}/fonts"))

gulp.task 'templates', ()->
    opts =
        moduleSystem: 'IIFE'
        module: 'main'
        root: '/'
    return gulp.src(paths.templates)
    .pipe(templatecache(opts))
    .pipe(rename({basename: 'tpls.min'}))
    .pipe(gulp.dest(paths.dest))

gulp.task 'connect', ()->
    opts =
        root: 'dist'
        livereload: true
        port: 3000

    connect.server(opts)

gulp.task 'livereload', ()->
    return gulp.src(paths.dest, {read: false})
    .pipe(connect.reload())

# Watch task
gulp.task 'watch', ()->
    gulp.watch paths.coffee, ['coffee']
    gulp.watch paths.styles, ['styles']
    gulp.watch paths.images, ['images']
    gulp.watch paths.templates, ['templates']
    return

# Composite tasks
gulp.task 'build', [
    'coffee'
    'styles'
    'images'
    'fonts'
    'templates'
    'usemin'
]

gulp.task 'default', ['build', 'watch', 'connect']
