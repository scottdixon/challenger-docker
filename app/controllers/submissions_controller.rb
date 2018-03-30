class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :test, :update, :destroy]

  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = Submission.all
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # GET /submissions/1/test
  def test

    # Is it a zip?
    if File.extname(@submission.submission_url) == '.zip'
      # Extract
      Zip::File.open("./public#{@submission.submission_url}") do |zip|
        zip.each do |file|
          file.extract("ruby_docker/lib/#{file.name}")
        end
      end
    else
      # Not a zip, copy single solution file
      FileUtils.cp("./public#{@submission.submission_url}", "ruby_docker/lib/#{@submission.challenge.challenge_identifier}")
    end

    # Copy tests from the original challenge
    FileUtils.cp("./public#{@submission.challenge.test_url}", "ruby_docker/tests/tests.rb")

    # Build container, run tests
    system('cd ruby_docker && docker build -t ruby-challenge -f Dockerfile.production . && docker build -t ruby-challenge-test -f Dockerfile.test .')
    @test_output = `docker run --rm ruby-challenge-test`
    @submission.passed = @test_output.include? '100% passed'
    @submission.save

    # Clean up
    system('rm -rf ruby_docker/lib/*')
    system('rm -rf ruby_docker/tests/*')
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @submission = Submission.new(submission_params)

    respond_to do |format|
      if @submission.save
        format.html { redirect_to "/submissions/#{@submission.id}/test" }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:challenge_id, :submission)
    end
end
