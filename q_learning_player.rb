class QLearningPlayer
  attr_accessor :x, :game

  def initialize
    @x = 0
    @actions = [:left, :right]
    @first_run = true

    @learning_rate = 0.2
    @discount = 0.9
    @epsilon = 0.9

    @r = Random.new
  end

  def initialize_q_table
    # Initialize q_table states by actions
    @q_table = Array.new(@game.map_size){ Array.new(@actions.length) }

    # Initialize to random values
    @game.map_size.times do |s|
      @actions.length.times do |a|
        @q_table[s][a] = @r.rand
      end
    end
  end

  def get_input
    # Pause to make sure humans can follow along
    sleep 0.05

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
      @outcome_state = @x
      @q_table[@old_state][@action_taken_index] = @q_table[@old_state][@action_taken_index] + @learning_rate * (r + @discount * @q_table[@outcome_state].max - @q_table[@old_state][@action_taken_index])
    end

    # Capture current state and score
    @old_score = @game.score
    @old_state = @x

    # Chose action based on Q value estimates for state
    if @r.rand > @epsilon
      # Select random action
      @action_taken_index = @r.rand(@actions.length).round
    else
      # Select based on Q table
      s = @x
      @action_taken_index = @q_table[s].each_with_index.max[1]
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
