# frozen_string_literal: true

RSpec.describe AzureDevops::Migrate do
  let(:dry_run) { described_class.new(issue_content, command) }
  let(:command) { Command.new(comment_body) }

  describe "#to_a" do
    subject { dry_run.to_a }
    let(:issue_content) do
      <<~ISSUE
        Organization: my-organization
        Project: my-project
      ISSUE
    end

    context "when the comment body does not contain a pipeline type" do
      let(:comment_body) { "/migrate" }

      it { is_expected.to eq(["pipeline", ["--azure-devops-organization", "my-organization"], ["--azure-devops-project", "my-project"]]) }
    end

    context "when the comment body contains a pipeline id" do
      let(:comment_body) { "/migrate --pipeline-id 42 --target-url https://github.com/org/repo" }

      it { is_expected.to eq(["pipeline", ["--azure-devops-organization", "my-organization"], ["--azure-devops-project", "my-project"], ["--pipeline-id", "42"], ["--target-url", "https://github.com/org/repo"]]) }
    end
  end
end
