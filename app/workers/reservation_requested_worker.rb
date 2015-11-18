class ReservationRequestedWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(user_id, reservation_token)
    user = User.find(user_id)
    reservation = Reservation.find_by_token(reservation_token)
    Api::V1::ReservationMailer.reservation_requested(user, reservation).deliver_now
  end
end