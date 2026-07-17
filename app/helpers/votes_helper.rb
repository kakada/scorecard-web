# frozen_string_literal: true

module VotesHelper
  def public_vote_form_data(form, scorecard)
    {
      scorecard_token: scorecard.token,
      duplicate_warning_required: form.duplicate_confirmation_required?,
      duplicate_device_submission_count: form.duplicate_device_submission_count,
      duplicate_device_submission_number: form.duplicate_device_submission_number,
      duplicate_profile_submission_count: form.duplicate_profile_submission_count,
      duplicate_warning_title: t("public_votes.duplicate_submission.title"),
      duplicate_device_message: t("public_votes.duplicate_submission.device_message"),
      duplicate_device_repeat_message: t("public_votes.duplicate_submission.device_repeat_message", ordinal: form.duplicate_device_submission_number),
      duplicate_profile_message: t("public_votes.duplicate_submission.profile_message", count: form.duplicate_profile_submission_count),
      duplicate_confirm_message: t("public_votes.duplicate_submission.confirm_message")
    }
  end
end
