class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforeフィルター

  # paramsハッシュからユーザーを取得します。
  def set_user
    if User.where(id: params[:id]).present?
      @user = User.find(params[:id])
    else
      flash[:danger] = "ユーザーが存在しません"
      redirect_to root_url
    end
  end

  def set_user_user_id
    @user = User.find(params[:user_id])
  end

  
  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # システム管理権限所有かどうか判定。
  def admin_user
    unless current_user.admin?
      flash[:danger] = "権限がありません"
      redirect_to root_url
    end
  end

  # アクセスしたユーザーが現在ログインしているユーザーまたは上長ユーザーかを確認
  def admin_or_correct_user
    if params[:id] == "1"
      redirect_to root_url
      return
    end
    unless current_user && (current_user?(@user) || current_user.superior?)
      flash[:danger] = "権限がありません"
      redirect_to root_url
    end
  end

  # ページ出力前に1ヶ月分のデータの存在を確認・セット。
  def set_one_month
    #パラムスの日付がないときは当月の最初の日
    @first_day = params[:date].nil? ?
      Date.current.beginning_of_month : params[:date].to_date
      
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    
    # ユーザーに紐付く一ヶ月分のレコードを検索して取得し、orderにて昇順に並び替えを行います。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    
    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
  
end