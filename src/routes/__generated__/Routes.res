// @generated
// This file is autogenerated, do not edit manually

module Main = {
  module Route = Route__Main_route

  module Vote = {
    module Route = Route__Main__Vote_route

    module Auction = {
      module Route = Route__Main__Vote__Auction_route

    }
  }
  module Question = {
    module Route = Route__Main__Question_route

    module Ask = {
      module Route = Route__Main__Question__Ask_route

      module UseVote = {
        module Route = Route__Main__Question__Ask__UseVote_route

      }
    }
    module Current = {
      module Route = Route__Main__Question__Current_route

    }
    module Past = {
      module Route = Route__Main__Question__Past_route

    }
  }
  module Queue = {
    module Route = Route__Main__Queue_route

  }
  module Raffles = {
    module Route = Route__Main__Raffles_route

  }
  module Votes = {
    module Route = Route__Main__Votes_route

  }
  module Questions = {
    module Route = Route__Main__Questions_route

  }
  module Auth = {
    module Route = Route__Main__Auth_route

    module Twitter = {
      module Route = Route__Main__Auth__Twitter_route

      module Callback = {
        module Route = Route__Main__Auth__Twitter__Callback_route

      }
    }
  }
}
module FourOhFour = {
  module Route = Route__FourOhFour_route

}