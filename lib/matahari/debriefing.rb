class Debriefing
  def initialize(expected_call_count = nil)
    @expected_call_count = expected_call_count
  end

	def matching_calls(verifying_args=true)
		@matching_calls ||= if verifying_args
			@invocations_of_method.select {|i| i[:args].flatten === @args_to_verify}.size
		else
			@invocations_of_method.size
		end
	end

	def match_passes?(verifying_args)
		if @expected_call_count
			matching_calls(verifying_args) == @expected_call_count
		else
			matching_calls(verifying_args) > 0
		end
	end

  def matches?(subject)
    @subject = subject
    @invocations_of_method = subject.invocations.select {|i| i[:method] == @call_to_verify}
    verifying_args = @args_to_verify.size != 0

    match_passes?(verifying_args)
  end

  def failure_message_for_should_not
    "Spy(:#{@subject.name}) expected not to receive :#{@call_to_verify} but received it #{prettify_times(@matching_calls)}"
  end

  def failure_message_for_should
    if @args_to_verify.size > 0
      "Spy(:#{@subject.name}) expected to receive :#{@call_to_verify}(#{@args_to_verify.map(&:inspect).join(", ")}) #{prettify_times(@expected_call_count)}, received #{prettify_times(@matching_calls)}"
    else
      "Spy(:#{@subject.name}) expected to receive :#{@call_to_verify} #{prettify_times(@expected_call_count)}, received #{prettify_times(@matching_calls)}"
    end
  end

  def method_missing(sym, *args, &block)
    @call_to_verify = sym
    @args_to_verify = args
    self
  end

  def prettify_times(times)
    case times
    when 1
      "once"
    when nil
      "once"
    when 2
      "twice"
    else
      "#{times} times"
    end
  end
  private :prettify_times
end
