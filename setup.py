# -*- coding: utf-8 -*-
import os
import subprocess
import sys
import sysconfig
from pathlib import Path

from setuptools import Extension
from setuptools import setup
from setuptools.command.build_ext import build_ext


class CMakeExtension(Extension):
    def __init__(self, name, sourcedir=''):
        super().__init__(name, sources=[])
        self.sourcedir = sourcedir


class CMakeBuild(build_ext):
    def run(self):
        for ext in self.extensions:
            self.build_extension(ext)

    def build_extension(self, ext: CMakeExtension):
        extdir = os.path.abspath(os.path.dirname(self.get_ext_fullpath(ext.name)))
        cmake_args = [
            '-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=' + extdir,
            '-DPython3_ROOT_DIR='+sysconfig.get_config_vars().get('installed_base'),
        ]
        cfg = 'Debug' if self.debug else 'Release'
        build_args = [
            '--config',
            cfg,
        ]

        if os.name == "nt":
            cmake_args += [
                '-DCMAKE_LIBRARY_OUTPUT_DIRECTORY_{}={}'.format(cfg.upper(), extdir)
            ]
        else:
            cmake_args += [
                '-DCMAKE_BUILD_TYPE=' + cfg
            ]

        env = os.environ.copy()
        if not os.path.exists(self.build_temp):
            os.makedirs(self.build_temp)
        subprocess.check_call(['cmake', str(Path().absolute())] + cmake_args, cwd=self.build_temp, env=env)
        subprocess.check_call(['cmake', '--build', '.'] + build_args, cwd=self.build_temp)


pyhash = CMakeExtension(name="_pyhash", sourcedir='.')

with open('README.md') as f:
    long_description = f.read()

setup(
    name='pyhash2',
    version='0.9.4',
    description='A fork of Python Non-cryptographic Hash Library',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/nnnewb/pyfasthash',
    download_url='https://github.com/nnnewb/pyfasthash/releases',
    platforms=["x86", "x64", "aarch64"],
    author='weak_ptr',
    author_email='weak_ptr@outlook.com',
    license="Apache Software License",
    license_files=["LICENSE.txt"],
    packages=['pyhash'],
    cmdclass=dict(build_ext=CMakeBuild),
    ext_modules=[pyhash],
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: Apache Software License',
        'Natural Language :: English',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: POSIX',
        'Programming Language :: C++',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: Implementation :: PyPy',
        'Topic :: Internet',
        'Topic :: Software Development',
        'Topic :: Software Development :: Libraries :: Python Modules',
        'Topic :: Utilities'
    ],
    keywords='hash hashing fasthash',
)
