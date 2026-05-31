pipelineJob('My-Automated-Projects/Hello-World-Pipeline-script') {
    description('This pipeline was injected at boot time from a local file.')
    // definition {
        // cps {
        //     // Reads the file from the seed job's workspace
        //     script(readFileFromWorkspace('./Jenkinsfile'))
        //     sandbox(true)
        // }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/HumaMilisic/DevOpsDemo.git')
                        // credentials('your-credential-id') // Uncomment if authentication is needed
                    }
                    branch('feat-setup')
                }
            }
            scriptPath('Jenkinsfile') // The path to the file inside the Git repo
        }
    }
    // }
}