---@type table<SceneType, table<ProcessType, Scene>>
Scenes = {
  Cocaine = {
    process = {
      dict = 'anim@amb@business@coc@coc_unpack_cut_left@',
      pedAnim = 'coke_cut_v5_coccutter',
      scene = {
        {
          model = 'bkr_prop_coke_bakingsoda_o',
          anim = 'coke_cut_v5_bakingsoda',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'prop_cs_credit_card',
          anim = 'coke_cut_v5_creditcard',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'prop_cs_credit_card',
          anim = 'coke_cut_v5_creditcard^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        }
      }
    },

    package = {
      dict = 'anim@amb@business@coc@coc_packing_hi@',
      pedAnim = 'full_cycle_v3_pressoperator',
      scene = {
        {
          model = 'bkr_prop_coke_fullscoop_01a',
          anim = 'full_cycle_v3_scoop',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_doll',
          anim = 'full_cycle_v3_cocdoll',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_boxedDoll',
          anim = 'full_cycle_v3_boxedDoll',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_dollCast',
          anim = 'full_cycle_v3_dollcast',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_dollmould',
          anim = 'full_cycle_v3_dollmould',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_fullmetalbowl_02',
          anim = 'full_cycle_v3_cocbowl',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_dollCast',
          anim = 'full_cycle_v3_dollCast^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_dollCast',
          anim = 'full_cycle_v3_dollCast^2',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_dollCast',
          anim = 'full_cycle_v3_dollCast^3',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_press_01b',
          anim = 'full_cycle_v3_cokePress',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_dollboxfolded',
          anim = 'full_cycle_v3_FoldedBox',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_dollboxfolded',
          anim = 'full_cycle_v3_FoldedBox^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_dollboxfolded',
          anim = 'full_cycle_v3_FoldedBox^2',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        }
      }
    }
  },

  Meth = {
    process = {
      dict = 'anim@amb@business@meth@meth_monitoring_cooking@cooking@',
      pedAnim = 'chemical_pour_short_cooker',
      scene = {
        {
          model = 'bkr_prop_meth_ammonia',
          anim = 'chemical_pour_short_clipboard',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_fakeid_clipboard_01a',
          anim = 'chemical_pour_short_clipboard',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_fakeid_penclipboard',
          anim = 'chemical_pour_short_pencil',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_sacid',
          anim = 'chemical_pour_short_sacid',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
      }
    },

    package = {
      dict = 'anim@amb@business@meth@meth_smash_weight_check@',
      pedAnim = 'break_weigh_v3_char01',
      scene = {
        {
          model = 'bkr_prop_meth_bigbag_04a',
          anim = 'break_weigh_v3_box01',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_bigbag_03a',
          anim = 'break_weigh_v3_box01^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_fakeid_clipboard_01a',
          anim = 'break_weigh_v3_clipboard',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_openbag_02',
          anim = 'break_weigh_v3_methbag01',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_openbag_02',
          anim = 'break_weigh_v3_methbag01^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_openbag_02',
          anim = 'break_weigh_v3_methbag01^2',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_openbag_02',
          anim = 'break_weigh_v3_methbag01^3',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_openbag_02',
          anim = 'break_weigh_v3_methbag01^4',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_openbag_02',
          anim = 'break_weigh_v3_methbag01^5',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_openbag_02',
          anim = 'break_weigh_v3_methbag01^6',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_fakeid_penclipboard',
          anim = 'break_weigh_v3_pen',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_coke_scale_01',
          anim = 'break_weigh_v3_scale',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_meth_scoop_01a',
          anim = 'break_weigh_v3_scoop',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
      }
    }
  },

  Weed = {
    process = {
      dict = 'anim@amb@business@weed@weed_sorting_seated@',
      pedAnim = 'sorter_right_sort_v3_sorter02',
      scene = {
        {
          model = 'bkr_prop_weed_dry_01a',
          anim = 'sorter_right_sort_v3_weeddry01a',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_dry_01a',
          anim = 'sorter_right_sort_v3_weeddry01a^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_leaf_01a',
          anim = 'sorter_right_sort_v3_weedleaf01a',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_leaf_01a',
          anim = 'sorter_right_sort_v3_weedleaf01a^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bag_01a',
          anim = 'sorter_right_sort_v3_weedbag01a',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bud_02b',
          anim = 'sorter_right_sort_v3_weedbud02b',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bud_02b',
          anim = 'sorter_right_sort_v3_weedbud02b^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bud_02b',
          anim = 'sorter_right_sort_v3_weedbud02b^2',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },

        {
          model = 'bkr_prop_weed_bud_02b',
          anim = 'sorter_right_sort_v3_weedbud02b^3',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bud_02b',
          anim = 'sorter_right_sort_v3_weedbud02b^4',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bud_02b',
          anim = 'sorter_right_sort_v3_weedbud02b^5',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bud_02a',
          anim = 'sorter_right_sort_v3_weedbud02a',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bud_02a',
          anim = 'sorter_right_sort_v3_weedbud02a^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bud_02a',
          anim = 'sorter_right_sort_v3_weedbud02a^2',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bag_pile_01a',
          anim = 'sorter_right_sort_v3_weedbagpile01a',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_weed_bucket_open_01a',
          anim = 'sorter_right_sort_v3_bucket01a',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
      }
    },
  },

  Money = {
    process = {
      dict = 'anim@amb@business@cfm@cfm_cut_sheets@',
      pedAnim = 'extended_load_tune_cut_billcutter',
      scene = {
        {
          model = 'bkr_prop_fakeid_papercutter',
          anim = 'extended_load_tune_cut_papercutter',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_cutter_moneypage',
          anim = 'extended_load_tune_cut_singlemoneypage',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_cutter_moneypage',
          anim = 'extended_load_tune_cut_singlemoneypage^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },

        {
          model = 'bkr_prop_cutter_moneypage',
          anim = 'extended_load_tune_cut_singlemoneypage^2',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_fakeid_table',
          anim = 'extended_load_tune_cut_table',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_cutter_moneystack_01a',
          anim = 'extended_load_tune_cut_moneystack',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },


        {
          model = 'bkr_prop_cutter_moneystrip',
          anim = 'extended_load_tune_cut_singlemoneystrip',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_cutter_moneystrip',
          anim = 'extended_load_tune_cut_singlemoneystrip^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_cutter_moneystrip',
          anim = 'extended_load_tune_cut_singlemoneystrip^2',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },


        {
          model = 'bkr_prop_cutter_moneystrip',
          anim = 'extended_load_tune_cut_singlemoneystrip^3',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_cutter_moneystrip',
          anim = 'extended_load_tune_cut_singlemoneystrip^4',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_cutter_singlestack_01a',
          anim = 'extended_load_tune_cut_singlestack',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        }
      }
    },

    package = {
      dict = 'anim@amb@business@cfm@cfm_counting_notes@',
      pedAnim = 'paper_jam_v1_counter',
      scene = {
        {
          model = 'bkr_prop_clubhouse_chair_01',
          anim = 'paper_jam_v1_chair',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_money_wrapped_01',
          anim = 'paper_jam_v1_moneyWrap',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_money_unsorted_01',
          anim = 'paper_jam_v1_moneyUnsorted',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },

        {
          model = 'bkr_prop_coke_tin_01',
          anim = 'paper_jam_v1_moneyBin',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_money_wrapped_01',
          anim = 'paper_jam_v1_MoneyWrap^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_money_unsorted_01',
          anim = 'paper_jam_v1_moneyUnsorted^1',
          coords = vector3(0.0, 0.0, 1.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_tin_cash_01a',
          anim = 'paper_jam_v1_BinMoney',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
      }
    },

    wash = {
      dict = 'anim@amb@business@cfm@cfm_drying_notes@',
      pedAnim = 'loading_v3_worker',
      scene = {
        {
          model = 'bkr_prop_money_pokerbucket',
          anim = 'loading_v3_bucket',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_money_unsorted_01',
          anim = 'loading_v3_money01',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
        {
          model = 'bkr_prop_money_unsorted_01',
          anim = 'loading_v3_money01^1',
          coords = vector3(0.0, 0.0, 0.0),
          heading = 0.0,
        },
      }
    }
  },
}
