defmodule VeritasWeb.VeritasLive do
  use Phoenix.LiveView


  def render(assigns) do
    ~L"""

    <form>
      <fieldset>
        <label for="nameField">Name</label>
        <input type="text" placeholder="CJ Patoilo" id="nameField">
        <label for="ageRangeField">Age Range</label>
        <select id="ageRangeField">
          <option value="0-13">0-13</option>
          <option value="14-17">14-17</option>
          <option value="18-23">18-23</option>
          <option value="24+">24+</option>
        </select>
        <label for="commentField">Comment</label>
        <textarea placeholder="Hi CJ …" id="commentField"></textarea>
        <div class="float-right">
          <input type="checkbox" id="confirmField">
          <label class="label-inline" for="confirmField">Send a copy to yourself</label>
        </div>
        <input class="button-primary" type="submit" value="Send">
      </fieldset>
    </form>
    """
  end

  def mount(_session, socket) do

    {:ok, socket}
  end

end
