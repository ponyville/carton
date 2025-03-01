// Copyright 2020 Carton contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#if canImport(Combine)
import Combine
#else
import OpenCombine
#endif
import TSCBasic
import TSCUtility

struct Progress {
  let step: Int
  let total: Int
  let text: String
}

extension Publisher where Output == Progress {
  func handle(
    with progressAnimation: ProgressAnimationProtocol
  ) -> Publishers.HandleEvents<Self> {
    handleEvents(
      receiveOutput: {
        progressAnimation.update(step: $0.step, total: $0.total, text: $0.text)
      },
      receiveCompletion: {
        switch $0 {
        case .finished:
          progressAnimation.complete(success: true)
        case .failure:
          progressAnimation.complete(success: false)
        }
      }
    )
  }
}
