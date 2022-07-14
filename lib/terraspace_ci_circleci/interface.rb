require "uri"

module TerraspaceCiCircleci
  class Interface
    # Interface method. Returns Hash of properties.
    def vars
      {
        build_system: "circleci",
        host: host,
        full_repo: full_repo,
        branch_name: ENV['CIRCLE_BRANCH'],
        # urls
        pr_url: ENV['CIRCLE_PULL_REQUEST'],
        build_url: ENV['CIRCLE_BUILD_URL'],
        # additional properties
        build_type: build_type,
        pr_number: pr_number,
        sha: ENV['CIRCLE_SHA1'],
        # additional properties
        # commit_message: ENV['REPLACE_ME'],
        build_id: ENV['CIRCLE_BUILD_NUM'],
        build_number: ENV['CIRCLE_BUILD_NUM'],
      }
    end

    # IE: CIRCLE_BUILD_URL=https://circleci.com/gh/ORG/REPO/7
    def host
      uri = URI(ENV['CIRCLE_BUILD_URL'])
      "#{uri.scheme}://#{uri.host}"
    end

    # IE: CIRCLE_REPOSITORY_URL=git@github.com:ORG/REPO.git
    def full_repo
      url = ENV['CIRCLE_REPOSITORY_URL']
      full_repo = if url.include?(':')
        url.split(':').last
      else
        URI(url).path.sub(%r{^/},'')
      end
      full_repo.sub('.git','')
    end

    def build_type
      ENV['CIRCLE_PULL_REQUEST'] ? 'pull_request' : 'push'
    end

    # CIRCLE_PULL_REQUEST=https://github.com/ORG/REPO/pull/2
    def pr_number
      pr = ENV['CIRCLE_PULL_REQUEST']
      pr.split('/').last if pr
    end
  end
end
