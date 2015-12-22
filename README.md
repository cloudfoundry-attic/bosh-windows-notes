# bosh-windows-notes

## Examples

### script style
The basic idea was we could abstract away monit by having each job provide scripts following certain conventions for filenames. We realized however that this would restrict each job to only being able to start a single process, and so this approach doesn't seem tenable without some other specification. Simply having the scripts fork multiple subprocesses isn't a great idea because it would then leave responsbility for monitoring to the scripts themselves, rather than allowing the supervisor to do that work.

### config style
This approach introduces a new file to the base of the job directory, [processes.yml](config-style/jobs/jenkins/processes.yml), that allows the user to describe what processes are to be started for the job and where the lifecycle scripts live. We took inspiration from Concourse's configuration, and we tried to make it unnecessary to use `erb` templating for these files. To that end, we added `instances` as a keypair that you can use to specify how many instances of a particular process you want to start. The idea would be that in a manifest you could override these defaults, through something like `properties.jenkins_server.instances: 5`. In this case it would be up to the agent to assign each process a unique name in Monit or Windows Services.

We also played around with the idea of allowing some limited interpolation, more like how Concourse's `--var` flag works rather than full blown `erb`. The idea in general is to try to keep the file as data-oriented as possible, and not let it become too much of a script.

## Questions

### Varying the processes run by a job:
- how much configurability is required? can we get away with "values only" interpolation, or do we need full-blown `erb` templating?
- examples in the wild:
  - the number of instances of a process (https://github.com/cloudfoundry/bosh/blob/ed9be10942e932958aa3aa42f7d46d2dd5f3997c/release/jobs/director/monit#L9)
  - whether it runs at all based on booleans (https://github.com/cloudfoundry-incubator/consul-release/blob/6cef9ce124b9df138ed1ef0ef4159f5807bc8a2a/jobs/consul_agent/monit#L7)
    - maybe these imperative booleans imply separate inter-dependent releases?
- an idea for concourse-style "values only" interpolation: https://github.com/cloudfoundry-incubator/bosh-windows-notes/blob/e7d75d32eebd27b828d39235c773bd0435700199/config-style/jobs/jenkins/processes.yml.erb#L12

### Stop scripts
- do we need to allow users to provide a prestop script? do all Monit ctl scripts just call `kill_and_wait`?

### Named groups, other monit features
- can things like `group vcap` and `with pidfile ...` be abstracted away because nobody actually cares about them in the first place?

### Windows specific
- Can we support installing MSIs? [Chocolatey](https://chocolatey.org) does
  this. An example that installs from an MSI is the [Ruby package](https://chocolatey.org/packages/ruby).
