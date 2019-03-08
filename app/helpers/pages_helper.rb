module PagesHelper

  def activeRoom(getID, index)
    if getID == index
      "room-active"
    else
      "room-inactive"
    end
  end

end
