// Copyright (c) 2021-2022 Doc.ai and/or its affiliates.
//
// Copyright (c) 2023 Cisco and/or its affiliates.
//
// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main_test

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

func TestExample(t *testing.T) {
	artsDir := os.Getenv("ARTIFACTS_DIR")
	if artsDir == "" {
		artsDir = "logs"
	}

	cmd := exec.Command("pwd")
	stdout, _ := cmd.Output()
	fmt.Printf("pwd: %s\n", string(stdout))
	fmt.Printf("log path: %s\n", filepath.Join("./", artsDir, "/helloworld.txt"))
	os.WriteFile(filepath.Join("./", "artsDir", "/helloworld.txt"), []byte("Hello, World!"), os.ModePerm)
	os.WriteFile(filepath.Join("./", artsDir, "/helloworld.txt"), []byte("Hello, World!"), os.ModePerm)

	cmd = exec.Command("ls")
	stdout, _ = cmd.Output()
	fmt.Printf("ls: %s\n", string(stdout))

	cmd = exec.Command("ls", "..")
	stdout, _ = cmd.Output()
	fmt.Printf("ls ..: %s\n", string(stdout))

	cmd = exec.Command("ls", "../../..")
	stdout, _ = cmd.Output()
	fmt.Printf("ls ../../..: %s\n", string(stdout))

	cmd = exec.Command("ls", "../../../..")
	stdout, _ = cmd.Output()
	fmt.Printf("ls ../../../..: %s\n", string(stdout))
}
