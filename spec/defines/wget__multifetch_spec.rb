# Copyright 2013 Michael Jerger
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'wget::multifetch' do
  let(:title) { 'multifetchname' }
  let(:node) { 'wget.jerger.org' }
  let(:facts) { { :operatingsystem => 'ubuntu' } }
  let(:params) { { :destination => 'dest', :source_base => 'src', :names => ['name1', 'name2'] } }
    
  it { should contain_exec('name1').with(
    'command' => '/usr/bin/wget --user= --output-document=dest/name1 src/name1',
  ) }
  it { should contain_exec('name2').with(
    'command' => '/usr/bin/wget --user= --output-document=dest/name2 src/name2',
  ) }
end