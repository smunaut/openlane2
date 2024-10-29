# Copyright 2024 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  ninja,
  numpy,
  pathspec,
  zlib,
  qhull,
  scikit-build-core,
  pyproject-metadata,
  version ? "0.9.52",
  sha256 ? "sha256-QiZyktJy9KTIIpCR3IOkltChX5ac82aTtVl9P+jvuS8=",
}: let
  self = buildPythonPackage {
    pname = "gdstk";
    format = "pyproject";
    inherit version;
    
    prePatch = ''
      sed -Ei.bak 's/cmake.version = ">=(.+?)"/cmake.minimum-version = "\1"/' pyproject.toml
      sed -i.bak '/oldest-supported-numpy/d' pyproject.toml
    '';

    nativeBuildInputs = [
      scikit-build-core
      cmake
      ninja
      pyproject-metadata
    ];
    
    dontUseCmakeConfigure = true;
    
    buildInputs = [
      zlib
      qhull
    ];

    propagatedBuildInputs = [
      numpy
      pathspec
    ];

    src = fetchPypi {
      inherit (self) pname version;
      inherit sha256;
    };
    doCheck = false;

    meta = {
      description = "Python module for creation and manipulation of GDSII files.";
      homepage = "https://github.com/heitzmann/gdstk";
      license = [lib.licenses.boost];
      platforms = lib.platforms.unix;
    };
  };
in self
