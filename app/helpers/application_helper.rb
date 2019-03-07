module ApplicationHelper


  # RECEIVE BOOLEAN IF USER IS LOGGED
  # RETRIEVE CORRECT MENU PATH TO AVOID THAT REDIRECTION
  # JUST BECAUSE IT IS FRIGGIN' UGLY ON THE CONSOLE AND MY SERVER IS SHITTY
  def getRootPath
    if isLogged?
      chat_path
    else
      root_path
    end
  end

end
