class QLearningPlayer
  attr_accessor :x, :y, :game

  def initialize
    @x = 0
    @y = 0
    @actions = [:left, :right, :up, :down]
    @first_run = true

    @learning_rate = 0.2
    @discount = 0.9
    @epsilon = 0.9

    @r = Random.new
  end

  def initialize_q_table
    # Initialize q_table states by actions
    @q_table = Array.new(@game.map_size_y){ Array.new(@game.map_size_x) { Array.new(@game.map_size_y){ Array.new(@game.map_size_x) { Array.new(@actions.length) } } } }

    # Initialize to random values
    @game.map_size_y.times do |y|
      @game.map_size_x.times do |x|
        @game.map_size_y.times do |cheese_y|
          @game.map_size_x.times do |cheese_x|
            @actions.length.times do |a|
              @q_table[y][x][cheese_y][cheese_x][a] = @r.rand
            end
          end
        end
      end
    end
  end

  def get_input
    # Pause to make sure humans can follow along
    sleep 0.01

    if @first_run
      # If this is first run initialize the Q-table
      initialize_q_table
      @first_run = false
    else
      # If this is not the first run
      # Evaluate what happened on last action and update Q table
      # Calculate reward
      r = 0 # default is 0
      if @old_score < @game.score
        r = 1 # reward is 1 if our score increased
      elsif @old_score > @game.score
        r = -1 # reward is -1 if our score decreased
      end

      # Our new state is equal to the player position
      @outcome_state = { x: @x, y: @y, cheese_x: @game.cheese_x, cheese_y: @game.cheese_y }
      @q_table[@old_state[:y]][@old_state[:x]][@old_state[:cheese_y]][@old_state[:cheese_x]][@action_taken_index] = @q_table[@old_state[:y]][@old_state[:x]][@old_state[:cheese_y]][@old_state[:cheese_x]][@action_taken_index] + @learning_rate * (r + @discount * @q_table[@outcome_state[:y]][@outcome_state[:x]][@outcome_state[:cheese_y]][@outcome_state[:cheese_x]].max - @q_table[@old_state[:y]][@old_state[:x]][@old_state[:cheese_y]][@old_state[:cheese_x]][@action_taken_index])
    end

    # Capture current state and score
    @old_score = @game.score
    @old_state = { x: @x, y: @y, cheese_x: @game.cheese_x, cheese_y: @game.cheese_y }

    # Chose action based on Q value estimates for state
    if @r.rand > @epsilon
      # Select random action
      @action_taken_index = @r.rand(@actions.length).round
    else
      # Select based on Q table
      s = {x: @x, y: @y,cheese_x: @game.cheese_x, cheese_y: @game.cheese_y }
      @action_taken_index = @q_table[s[:y]][s[:x]][s[:cheese_y]][s[:cheese_x]].each_with_index.max[1]
    end

    # Take action
    return @actions[@action_taken_index]
  end


  def print_table
    @q_table.length.times do |i|
      puts @q_table[i].to_s
    end
  end

end
