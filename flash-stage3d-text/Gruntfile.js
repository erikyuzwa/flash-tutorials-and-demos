

module.exports = function(grunt) {

    var cmdFlashArgs = [
        '-use-network=true',
        '-headless-server=true',
        '-debug=false',
        '-static-link-runtime-shared-libraries=true'
    ];

    grunt.initConfig({
        copy: {
            build: {
                files: [
                    // includes files within path and its sub-directories
                    {expand: true, cwd: 'app/', src: ['**', '!src/**', '!styles/*.scss'], dest: 'build/'}
                ],
            },

        },
        connect: {
            build: {
              options: {
                port: 3000,
                hostname: '*',
                base: 'build',
                keepalive: true,
                open: true
                //onCreateServer: function(server, connect, options) {
                //  var io = require('socket.io').listen(server);
                //  io.sockets.on('connection', function(socket) {
                    // do something with socket
                //  });
               // }
              }
            }
        },
        babel: {
            build: {
                options: {
                    sourceMap: true,
                    presets: ['es2015']
                },
                files: {
                    'build/bundle.js': './app/src/js/app.js'
                }
            }
        },
        mxmlc: {
            options: {
                rawConfig: cmdFlashArgs.join(' ')
            },
            build: {
                files: {
                 'build/example.swf': ['app/scripts/as/Main.as']
                }
            }
        },
        jshint: {
            files: ['app/scripts/js/**/*.js'],
            options: {
                globals: {
                    jQuery: true
                }
            }
        },
        watch: {
            files: ['<%= jshint.files %>'],
            tasks: ['jshint']
        },
        sass: {
            build: {
                options: {
                    style: 'expanded'
                },
                files: {
                    'app/styles/app.css': 'app/styles/app.scss',
                }
            }
        },
        uglify: {
            options: {
                mangle: false
            },
            build: {
                files: {
                    'build/bundle.min.js': ['<%= jshint.files %>']
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-mxmlc');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-babel');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-connect');

    grunt.registerTask('default', ['jshint', 'sass:build', 'uglify', 'mxmlc:build', 'copy:build', 'connect:build']);

};
