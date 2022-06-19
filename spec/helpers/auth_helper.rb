# frozen_string_literal: true

module AuthHelper
  # FIXME: introduce a `token` param to tie a specific header to this
  # specific user and prevent multiple calls here from bypassing auth.
  def mock_auth!(user)
    allow(JsonWebToken).to(
      receive(:verify)
        .and_return([{ 'sub' => user.auth_provider_id }]),
    )
  end
end
