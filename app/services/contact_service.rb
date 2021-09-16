class ContactService
  def initialize(program)
    @program = program
  end

  def as_json
    program.contacts
  end

  private

  def program
    @program || NoProgram.new
  end
end
