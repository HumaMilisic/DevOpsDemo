folder('My-Automated-Projects') {
    description('A folder created on startup')
}

pipelineJob('My-Automated-Projects/Hello-World-Pipeline') {
    description('This pipeline was injected at boot time.')
    definition {
        cps {
            script('''
                pipeline {
                    agent any
                    stages {
                        stage('Verify Setup') {
                            steps {
                                echo '✅ JCasC and Job DSL are working perfectly!'
                                sh 'java -version'
                            }
                        }
                    }
                }
            '''.stripIndent())
            sandbox(true)
        }
    }
}